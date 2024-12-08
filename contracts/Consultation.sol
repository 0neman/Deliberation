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
        address id;
        string name;
    }

    struct Consultation {
        string title;
        bool isClosed;
        uint32 startTime;
        uint32 endTime;
        Student[] students;
    }

    struct Vote {
        Teacher teacher;
        Student student;
        Choices choice;
    }

    Teacher[] teachers;
    Consultation[] consultations;

    function addNewStudent(
        string memory name,
        uint32 id,
        uint consultation,
        Grades level,
        uint16 credit,
        uint16 mark
    ) public {
        consultations[consultation].students.push(
            Student(name, id, level, credit, mark)
        );
        emit StudentCreated(name, id, level, credit, mark);
    }

    function addNewTeacher(address id, string memory name) public {
        teachers.push(Teacher(id, name));
    }

    function createNewConsultation(
        string memory title,
        bool isClosed,
        uint32 startTime,
        uint32 endTime
    ) public {
        Student[] memory student;
        consultations.push(
            Consultation(title, isClosed, startTime, endTime, student)
        );
    }
}
