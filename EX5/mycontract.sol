pragma solidity >=0.4.22 <0.6.0;

contract BlockchainSplitwise {
    
    // 用户结构，包含他们欠其他用户的债务及其最后操作的时间戳
    struct User {
        mapping (address => uint32) debts; // 映射其他用户的地址到欠他们的债务
        uint timestamp; // 用户的最后操作时间戳
    }
    
    // 一个映射，包含所有用户的地址和他们的User结构实例
    mapping (address => User) public users;
    
    // 返回债务人欠债权人的债务
    function lookup(address debtor, address creditor) public view returns (uint32 ret) {
        return users[debtor].debts[creditor];
    }
    
    // 添加债务人欠债权人的新债务，考虑存在的债务循环并做出相应调整
    function add_IOU(address creditor, uint32 amount, address[] memory cycle, uint32 minDebt) public {
        // 检查输入的金额和最低债务不能为负数
        require (amount >= 0, 'Negative amount');
        require (minDebt >= 0, 'Negative minDebt');
        
        if(cycle.length == 0){
            // 如果没有循环，直接增加债务
            users[msg.sender].debts[creditor] += amount;
        } else {
            // 检查发件人是否在循环的末尾
            for(uint i = 0; i < (cycle.length - 1); i++){
                // 确保循环中所有的债务都大于或等于最小债务
                require(lookup(cycle[i], cycle[i+1]) >= minDebt);
                // 减去从每个用户的债务中的最小债务
                users[cycle[i]].debts[cycle[i+1]] -= minDebt;
            }
            
            // 为最后一个用户增加债务，并减去最小债务
            users[cycle[cycle.length-1]].debts[cycle[0]] += amount;
            users[cycle[cycle.length-1]].debts[cycle[0]] -= minDebt;
        }
        
        // 更新债务人和债权人的最后操作时间
        update_timestamp(msg.sender);
        update_timestamp(creditor);
    }
    
    // 更新用户的最后操作时间
    function update_timestamp(address user) public {
        users[user].timestamp = block.timestamp;
    }
    
    // 返回用户的最后操作时间
    function get_timestamp(address user) public view returns (uint timestamp){
        return users[user].timestamp;
    }
}