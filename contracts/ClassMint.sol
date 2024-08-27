// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ParticipationToken {
    // Variables
    string public name = "Participation Token";
    string public symbol = "PTKN";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    // Mapping from student address to balance of tokens
    mapping(address => uint256) public balanceOf;

    // Mapping to track teacher addresses who are authorized to distribute tokens
    mapping(address => bool) public teachers;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event TeacherAdded(address indexed teacher);
    event TeacherRemoved(address indexed teacher);

    // Constructor to set initial total supply and assign it to the contract deployer (e.g., the admin or school)
    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * (10 ** uint256(decimals));
        balanceOf[msg.sender] = totalSupply;
    }

    // Modifier to check if the caller is a teacher
    modifier onlyTeacher() {
        require(teachers[msg.sender], "You are not authorized to distribute tokens");
        _;
    }

    // Function to add a teacher
    function addTeacher(address _teacher) external {
        require(msg.sender == address(this), "Only the contract can add teachers");
        teachers[_teacher] = true;
        emit TeacherAdded(_teacher);
    }

    // Function to remove a teacher
    function removeTeacher(address _teacher) external {
        require(msg.sender == address(this), "Only the contract can remove teachers");
        teachers[_teacher] = false;
        emit TeacherRemoved(_teacher);
    }

    // Function for teachers to reward students with tokens
    function rewardStudent(address _student, uint256 _amount) external onlyTeacher {
        require(_student != address(0), "Invalid student address");
        require(_amount <= balanceOf[msg.sender], "Insufficient tokens");
        
        balanceOf[msg.sender] -= _amount;
        balanceOf[_student] += _amount;

        emit Transfer(msg.sender, _student, _amount);
    }

    // Function to transfer tokens between students
    function transfer(address _to, uint256 _amount) external {
        require(_to != address(0), "Invalid recipient address");
        require(_amount <= balanceOf[msg.sender], "Insufficient tokens");

        balanceOf[msg.sender] -= _amount;
        balanceOf[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);
    }

    // Function to view the balance of a student or teacher
    function getBalance(address _account) external view returns (uint256) {
        return balanceOf[_account];
    }
}

