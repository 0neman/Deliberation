// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.27;

contract Consultations {
    event StudentCreated(
        string name,
        uint32 id,
        Grades level,
        uint16 credit,
        uint16 mark
    );

    event consultationCreated(
        string title,
        bool isClosed,
        uint32 startTime,
        uint32 endTime
    );

    event voted(
        uint32 idStudent,
        uint consultationId,
        uint32 idTeacher,
        uint choice
    );

    enum Choices {
        Sure,
        FairlyConfident,
        SomhowConfident,
        NotEntierlySure,
        Uncertain,
        Doubtful
    }

    enum Grades {
        first,
        second,
        third,
        forth,
        fifth
    }

    struct Student {
        string name;
        uint32 id;
        Grades level;
        uint16 credit;
        uint16 mark;
    }

    struct Teacher {
        uint32 id;
        string name;
    }

    struct Consultation {
        string title;
        bool isClosed;
        uint32 startTime;
        uint32 endTime;
    }

    struct Vote {
        uint32 teacher;
        uint32 student;
        Choices choice;
    }

    Student[] public students;
    mapping(uint => mapping(uint => Vote)) public votes;
    Teacher[] public teachers;
    Consultation[] public consultations;
    uint vote;

    function addNewStudent(
        string memory name,
        uint32 id,
        uint consultationId,
        uint level,
        uint16 credit,
        uint16 mark
    ) public {
        require(
            consultations.length > 0 &&
                !consultations[consultationId].isClosed &&
                credit < 300 &&
                level < 4
        );
        students.push(Student(name, id, Grades(level), credit, mark));
        emit StudentCreated(name, id, Grades(level), credit, mark);
    }

    function addNewTeacher(uint32 id, string memory name) public {
        teachers.push(Teacher(id, name));
    }

    function createNewConsultation(
        string memory title,
        uint32 startTime,
        uint32 endTime
    ) public {
        startTime = uint32(block.timestamp);
        endTime = uint32(block.timestamp) + 5000;
        consultations.push(
            Consultation(
                title,
                startTime <= block.timestamp,
                startTime,
                endTime
            )
        );
        emit consultationCreated(
            title,
            startTime <= block.timestamp,
            endTime,
            endTime
        );
    }

    function _voting(
        uint32 idStudent,
        uint consultationId,
        uint voteId,
        uint32 idTeacher,
        uint choice
    ) public {
        require(choice > 4 && !consultations[consultationId].isClosed);
        votes[consultationId][voteId] = Vote(
            idTeacher,
            idStudent,
            Choices(choice)
        );
        emit voted(idStudent, consultationId, idTeacher, choice);
    }

    function getStudentVotes(uint consultationId) public view returns (uint) {
        uint sum = 0;
        for (uint i = 0; i < students.length; i++) {
            if (votes[consultationId][i].student == students[i].id) {
                sum = sum + uint(votes[consultationId][i].choice);
            }
        }
        return sum;
    }
}
