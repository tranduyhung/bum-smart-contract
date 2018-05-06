pragma solidity ^0.4.18;

import './ERC20.sol';

/// @title BUM Token
/// @author Hung Tran <nguyentieuhau@gmail.com>
/// @dev Very basic Ethereum token for learning purpose. Use this at your own risk.
contract BumToken is ERC20 {
  /// @dev Token's name.
  string public name;

  /// @dev Token's symbol.
  string public symbol;

  /// @dev Token's decimal quantity.
  /// @dev 18 decimals is the strongly suggested default, avoid changing it.
  uint8 public decimals = 18;

  /// @dev Total tokens.
  uint256 public totalSupply;

  /// @dev Array of all balances.
  mapping (address => uint256) public balanceOf;

  /// @dev Array of allowances.
  mapping (address => mapping (address => uint256)) public allowance;

  /// @dev Notify all users about transactions.
  event Transfer(address indexed from, address indexed to, uint256 value);

  /// @dev Notify all users about amount burnt.
  event Burn(address indexed from, uint256 value);

  /// @dev Constructor.
  /// @param _initialSupply Initial tokens.
  /// @param _tokenName Token's name.
  /// @param _tokenSymbol Token's symbol.
  constructor(uint256 _initialSupply, string _tokenName, string _tokenSymbol) public {
    // Update total supply with decimal amount.
    totalSupply = _initialSupply * 10 ** uint256(decimals);

    // Give the creator all inital tokens.
    balanceOf[msg.sender] = totalSupply;

    // Set token name.
    name = _tokenName;

    // Set token symbol.
    symbol = _tokenSymbol;
  }

  /// @return The name of the token.
  function name() public view returns (string tokenName) {
    return name;
  }

  /// @return The symbol of the token.
  function symbol() public view returns (string tokenSymbol) {
    return symbol;
  }

  /// @return The number of decimals the token uses.
  function decimals() public view returns (uint8 tokenDecimals) {
    return decimals;
  }

  /// @return The total token supply.
  function totalSupply() public view returns (uint256 total) {
    return totalSupply;
  }

  /// @param _owner Address of user.
  /// @return Account balance of user.
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balanceOf[_owner];
  }

  /// @dev Send token to another user.
  /// @param _to Address of recipient.
  /// @param _value  Amount to send.
  /// @return true if the transfer is successful.
  function transfer(address _to, uint256 _value) public returns (bool success) {
    // Prevent transtering to 0x0 address. Use burn() instead.
    require(_to != 0x0);

    // Check if sender has enough token to send.
    require(balanceOf[msg.sender] >= _value);

    // Check for overflows.
    require(balanceOf[_to] + _value >= balanceOf[_to]);

    // Save this for an assertion in future.
    uint previousBalances = balanceOf[msg.sender] + balanceOf[_to];

    // Substract from sender.
    balanceOf[msg.sender] -= _value;

    // Add the same to recipient.
    balanceOf[_to] += _value;

    emit Transfer(msg.sender, _to, _value);

    // Assert for static analysis to find bugs. This should never fail.
    assert(balanceOf[msg.sender] + balanceOf[_to] == previousBalances);

    return true;
  }

  /// @dev Transfers _value amount of tokens to address _to on behalf of _from.
  /// @param _from The address of sender.
  /// @param _to The address of recipient.
  /// @param _value The amount to transfer.
  /// @return true if the transfer is successful.
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    // Prevent transtering to 0x0 address. Use burn() instead.
    require(_to != 0x0);

    // Check if sender has enough token to send.
    require(balanceOf[_from] >= _value);

    // Check if sender allows user to transfer this amount of tokens.
    require(allowance[_from][msg.sender] >= _value);

    // Check for overflows.
    require(balanceOf[_to] + _value >= balanceOf[_to]);

    // Save this for an assertion in future.
    uint previousBalances = balanceOf[_from] + balanceOf[_to];

    // Substract from sender.
    balanceOf[_from] -= _value;

    // Substract from allowance.
    allowance[_from][msg.sender] -= _value;

    // Add the same to recipient.
    balanceOf[_to] += _value;

    emit Transfer(_from, _to, _value);

    // Assert for static analysis to find bugs. This should never fail.
    assert(balanceOf[_from] + balanceOf[_to] == previousBalances);

    return true;
  }

  /// @dev Approve _spender to widthdraw from user's account multiple times, up to the _value amount.
  /// @param _spender Address of spender.
  /// @param _value The max amount spender can spend.
  /// @return true if approval is successful.
  function approve(address _spender, uint256 _value) public returns (bool success) {
    allowance[msg.sender][_spender] = _value;

    return true;
  }

  /// @dev Returns the amount which _spender is still allowed to withdraw from _owner.
  /// @param _owner Address of owner.
  /// @param _spender Address of spender.
  /// @return The remaining amount _spender can spend.
  function allowance(address _owner, address _spender) public view returns (uint256 reamining) {
    return allowance[_owner][_spender];
  }

  /// @dev Burn tokens.
  /// @param _value Amount of token to burn.
  /// @return true If burn successfully.
  function burn(uint256 _value) public returns (bool success) {
    // Check if user has enough tokens.
    require(balanceOf[msg.sender] >= _value);

    // Substract from user.
    balanceOf[msg.sender] -= _value;

    // Update total supply.
    totalSupply -= _value;

    emit Burn(msg.sender, _value);

    return true;
  }

  /// @dev Destroy _value tokens from the system on behalf of _from.
  /// @param  _from  Address of token's owner.
  /// @param _value  Amount to burn.
  /// @return true if Burn successfully.
  function burnFrom(address _from, uint256 _value) public returns (bool success) {
    // Check if targeted balance has enough token.
    require(balanceOf[_from] >= _value);

    // Check if user is allowed to spend tokens on behalf of owner.
    require(allowance[_from][msg.sender] >= _value);

    // Substract owner's tokens.
    balanceOf[_from] -= _value;

    // Substract from spender's allowance.
    allowance[_from][msg.sender] -= _value;

    emit Burn(_from, _value);

    return true;
  }
}
