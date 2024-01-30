Name: []

## Question 1

In the following code-snippet from `Num2Bits`, it looks like `sum_of_bits`
might be a sum of products of signals, making the subsequent constraint not
rank-1. Explain why `sum_of_bits` is actually a _linear combination_ of
signals.

```
        sum_of_bits += (2 ** i) * bits[i];
```

## Answer 1

`sum_of_bits`通过将`bits`数组中的每个值乘以`2`的特定次幂然后求和来赋值的。$2^i$是一个常数，因为`i`在编译时循环遍历一个已知的`n`，这意味着`bits`数组中的每个信号都乘以一个常数，然后相加，这是线性组合的定义。

## Question 2

Explain, in your own words, the meaning of the `<==` operator.

## Answer 2

`<==` 运算符是两个独立运算符的组合，即 `<--` 和 `===` 运算符。`<--`给一个变量赋予特定的值，而`===`确保该变量受到等式另一侧的约束。因此`<==` 运算符将一个值赋给一个变量，并确保该变量受限于仅为这个值。

## Question 3

Suppose you're reading a `circom` program and you see the following:

```
    signal input a;
    signal input b;
    signal input c;
    (a & 1) * b === c;
```

Explain why this is invalid.

## Answer 3

约束操作只能通过信号的线性组合进行分配，即只能有乘法或加法。在题目中有一个按位运算符`&`作用于`a`和`1`。因为按位与不是加法或乘法，将其用作约束的一部分是无效的。