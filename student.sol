// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ScoreCard {
    address public classTeacher;

    struct Student {
        string firstName;
        string lastName;
        uint256 englishMarks;
        uint256 mathMarks;
        uint256 scienceMarks;
    }

    Student[] public students;

    event StudentAdded(string indexed _studentFirstName, string indexed _studentLastName, uint256 _studentId);
    event StudentScoreRecorded(uint256 indexed _studentId, uint256 _englishMarks, uint256 _mathMarks, uint256 _scienceMarks);

    constructor() {
        classTeacher = msg.sender;
    }

    modifier onlyTeacher() {
        require(msg.sender == classTeacher, "Only class teacher can call this function");
        _;
    }

    function addStudent(
        string memory _studentFirstName,
        string memory _studentLastName,
        uint256 _englishMarks,
        uint256 _mathMarks,
        uint256 _scienceMarks
    ) public onlyTeacher {
        students.push(Student(_studentFirstName, _studentLastName, _englishMarks, _mathMarks, _scienceMarks));
        emit StudentAdded(_studentFirstName, _studentLastName, students.length - 1);
    }

    function recordStudentScore(
        uint256 _studentId,
        uint256 _englishMarks,
        uint256 _mathMarks,
        uint256 _scienceMarks
    ) public onlyTeacher {
        require(_studentId < students.length, "Student does not exist");

        students[_studentId].englishMarks = _englishMarks;
        students[_studentId].mathMarks = _mathMarks;
        students[_studentId].scienceMarks = _scienceMarks;

        emit StudentScoreRecorded(_studentId, _englishMarks, _mathMarks, _scienceMarks);
    }

    function getAllStudents()
        public
        view
        returns (
            string[] memory,
            uint256[] memory,
            uint256[] memory,
            uint256[] memory
        )
    {
        string[] memory studentNames = new string[](students.length);
        uint256[] memory englishMarks = new uint256[](students.length);
        uint256[] memory mathMarks = new uint256[](students.length);
        uint256[] memory scienceMarks = new uint256[](students.length);

        for (uint256 i = 0; i < students.length; i++) {
            studentNames[i] = string(abi.encodePacked(students[i].firstName, " ", students[i].lastName));
            englishMarks[i] = students[i].englishMarks;
            mathMarks[i] = students[i].mathMarks;
            scienceMarks[i] = students[i].scienceMarks;
        }

        return (studentNames, englishMarks, mathMarks, scienceMarks);
    }
}
