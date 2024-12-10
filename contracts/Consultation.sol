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

    mapping(uint => mapping(uint => Student)) public students;
    mapping(uint => mapping(uint => Vote)) public votes;
    Teacher[] public teachers;
    Consultation[] public consultations;

    function addNewStudent(
        string memory name,
        uint32 id,
        uint consultationId,
        uint level,
        uint16 credit,
        uint16 mark
    ) public {
        students[id][consultationId] = Student(
            name,
            id,
            Grades(level),
            credit,
            mark
        );
        emit StudentCreated(name, id, Grades(level), credit, mark);
    }

    function addNewTeacher(uint32 id, string memory name) public {
        teachers.push(Teacher(id, name));
    }

    function createNewConsultation(
        string memory title,
        bool isClosed,
        uint32 startTime,
        uint32 endTime
    ) public {
        startTime = uint32(block.timestamp);
        endTime = uint32(block.timestamp) + 5000;
        consultations.push(Consultation(title, isClosed, startTime, endTime));
    }

    function _voting(
        uint32 idStudent,
        uint consultationId,
        uint32 idTeacher,
        uint choice
    ) public {
        votes[uint(block.timestamp)][consultationId] = Vote(
            idTeacher,
            idStudent,
            Choices(choice)
        );
    }
}
