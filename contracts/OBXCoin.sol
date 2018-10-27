pragma solidity ^0.4.18;

import "./ERC20Interface.sol";
//PRE-LAUNCH
// Update comments for github release
// Update name var or move to constructor
contract ObxCoin is ERC20Interface {
    // Public variables of the token
    string public name = "OBXCoin";
    string public symbol = "OBX";
    uint8 public decimals = 18;
    // 18 decimals is the strongly suggested default, avoid changing it
    uint256 public totalSupply;
    address owner;
    // This creates an array with all balances
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;


 //Constructor
    function ObxCoin(uint256 initialSupply) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);  
        balances[msg.sender] = totalSupply;                
        owner = msg.sender;
    }

    /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, uint _value) internal {
       // Old burn method
        require(_to != 0x0);
        // Check if the sender has enough
        require(balances[_from] >= _value);
        // Check for overflows
        require(balances[_to] + _value > balances[_to]);
    
        uint previousBalances = balances[_from] + balances[_to];
    
        balances[_from] -= _value;

        balances[_to] += _value;
        Transfer(_from, _to, _value);

        assert(balances[_from] + balances[_to] == previousBalances);
        
    }

    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
         success = true;
         return success;
    }

    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     *
     * 
     * @param _value the amount to send
     */
    function mint(uint256 _value) public onlyOwner returns (bool success) {
         require(_value > 0);
         uint previousBalances = totalSupply;
        
         totalSupply += _value;
         balances[owner] += _value;
         assert(totalSupply == previousBalances + _value);
         return success;
         
    }
    /**
     * Transfer tokens from other address
     *
     * Send `_value` tokens to `_to` on behalf of `_from`
     *
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowed[_from][msg.sender]);     // Check allowance
        allowed[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    /**
     * Set allowance for other address
     *
     * Allows `_spender` to spend no more than `_value` tokens on your behalf
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     */
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
         Approval(msg.sender, _spender, _value);
        return true;
    }


 function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }   
    /**
     * Destroy tokens
     *
     * Remove `_value` tokens from the system irreversibly
     *
     * @param _value the amount of money to burn
     */
    function burn(uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value); 
        balances[msg.sender] -= _value;            
        totalSupply -= _value;                  
        Burn(msg.sender, _value);
        return true;
    }

    /**
     * Destroy tokens from other account
     *
     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
     *
     * @param _from the address of the sender
     * @param _value the amount of money to burn
     */
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balances[_from] >= _value);                
        require(_value <= allowed[_from][msg.sender]);   
        balances[_from] -= _value;                       
        allowed[_from][msg.sender] -= _value;            
        totalSupply -= _value;                              
        Burn(_from, _value);
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        balance = balances[_owner];
        return balance;
    }


    modifier onlyOwner() {
        require(msg.sender == owner); 
        _; 
    }
}
