pragma solidity ^0.4.18;

/// @title BUM Token
/// @author Hung Tran <nguyentieuhau@gmail.com>
/// @dev Very basic Ethereum token for learning purpose. Use this at your own risk.
contract BumToken {
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

  /// @dev Send token to another user.
  /// @param _to Address of recipient.
  /// @param _value  Amount to send.
  function transfer(address _to, uint256 _value) public {
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
}
