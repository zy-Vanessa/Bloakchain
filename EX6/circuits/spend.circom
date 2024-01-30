include "./mimc.circom";

/*
 * IfThenElse sets `out` to `true_value` if `condition` is 1 and `out` to
 * `false_value` if `condition` is 0.
 *
 * It enforces that `condition` is 0 or 1.
 *
 */
template IfThenElse() {
    signal input condition;
    signal input true_value;
    signal input false_value;
    signal output out;

    // TODO
    // Hint: You will need a helper signal...
    condition * (1 - condition) === 0;
    signal true_condition;
    signal false_condition;
    true_condition <== condition * true_value;
    false_condition <== (1 - condition) * false_value;
    out <== true_condition + false_condition;
}

/*
 * SelectiveSwitch takes two data inputs (`in0`, `in1`) and produces two ouputs.
 * If the "select" (`s`) input is 1, then it inverts the order of the inputs
 * in the ouput. If `s` is 0, then it preserves the order.
 *
 * It enforces that `s` is 0 or 1.
 */
template SelectiveSwitch() {
    signal input in0;
    signal input in1;
    signal input s;
    signal output out0;
    signal output out1;

    // TODO
    component ifthenelse0 = IfThenElse();
    component ifthenelse1 = IfThenElse();
    
    ifthenelse0.condition <== s;
    ifthenelse0.true_value <== in1;
    ifthenelse0.false_value <== in0;
    out0 <== ifthenelse0.out;
    
    ifthenelse1.condition <== s;
    ifthenelse1.true_value <== in0;
    ifthenelse1.false_value <== in1;
    out1 <== ifthenelse1.out;

}

/*
 * Verifies the presence of H(`nullifier`, `nonce`) in the tree of depth
 * `depth`, summarized by `digest`.
 * This presence is witnessed by a Merle proof provided as
 * the additional inputs `sibling` and `direction`, 
 * which have the following meaning:
 *   sibling[i]: the sibling of the node on the path to this coin
 *               at the i'th level from the bottom.
 *   direction[i]: "0" or "1" indicating whether that sibling is on the left.
 *       The "sibling" hashes correspond directly to the siblings in the
 *       SparseMerkleTree path.
 *       The "direction" keys the boolean directions from the SparseMerkleTree
 *       path, casted to string-represented integers ("0" or "1").
 */
template Spend(depth) {
    signal input digest;
    signal input nullifier;
    signal private input nonce;
    signal private input sibling[depth];
    signal private input direction[depth];

    // TODO
    // 需要 depth+1 个中间路径哈希用于 Merkle 路径
    signal MerkleTree[depth+1];

    // coinHash是MerkleTree的第一个输入
    component coinHash = Mimc2();
    coinHash.in0 <== nullifier;
    coinHash.in1 <== nonce;
    MerkleTree[0] <== coinHash.out;

    // 需要 depth 个哈希和开关子电路用于 Merkle 路径
    component hash[depth];
    component switch[depth];

    // 在每个深度上，将前一个哈希与当前兄弟节点进行哈希，考虑到需要翻转的情况
    for (var i = 0; i < depth; ++i) {

        // 根据兄弟节点的方向设置左右节点 - 如果兄弟节点在左边，需要翻转
        switch[i] = SelectiveSwitch();
        switch[i].in0 <== MerkleTree[i];
        switch[i].in1 <== sibling[i];
        switch[i].s <== direction[i];

        hash[i] = Mimc2();

        // 左节点
        hash[i].in0 <== switch[i].out0;

        // 右节点
        hash[i].in1 <== switch[i].out1;

        // 将左右节点哈希在一起，生成路径上的下一个哈希
        MerkleTree[i+1] <== hash[i].out;
    }

    // 检查顶部哈希 - 应强制为等于 MerkleTree 的根
    MerkleTree[depth] === digest;
}
