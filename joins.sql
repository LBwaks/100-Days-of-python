-- creating the database 
CREATE DATABASE IF NOT EXISTS KeyCardSystem;
-- instructing to use the database

USE KeyCardSystem;

-- alter table to allow table to be deleted by dropping foreign key constraint 
ALTER TABLE UserGroup
DROP FOREIGN KEY fk_users,
DROP FOREIGN KEY fk_groups;

-- alter table to allow table to be deleted by dropping foreign key constraint 
ALTER TABLE GroupRoom
DROP FOREIGN KEY fk_rooms,
DROP FOREIGN KEY fk_group_rooms;

-- dropping table to allow multiple rerun of screen 
DROP TABLE if EXISTS Users;
-- creating users table  
CREATE TABLE IF NOT EXISTS Users (
    userId INT PRIMARY KEY,
    userName VARCHAR(25)
);

-- populating users table 
INSERT INTO Users(userId,userName)
VALUES
(1,'Modestro'),
(2,'Ayine'),
(3,'Christopher'),
(4,'Cheong woo'),
(5,'Saulat'),
(6,'Heidy');

-- dropping table to allow multiple rerun of screen 
DROP TABLE if EXISTS Groupps;
-- creating groups table  
CREATE TABLE IF NOT EXISTS Groupps (
    groupId INT PRIMARY KEY,
    groupName VARCHAR(25)

);
-- populating groups table
INSERT INTO Groupps(groupId,groupName)
VALUES
(1,'I.T'),
(2,'Sales'),
(3,'Admistration'),
(4,'Operations');

-- dropping table to allow multiple rerun of screen 
DROP TABLE if EXISTS UserGroup;
-- creating a user group pivot table 
CREATE TABLE IF NOT EXISTS UserGroup(
    uGroupId Serial PRIMARY KEY,
    userId INT,
    groupId INT,
    CONSTRAINT fk_users FOREIGN KEY (userId) REFERENCES Users(userId)
    ON DELETE CASCADE,

    CONSTRAINT fk_groups FOREIGN KEY (groupId) REFERENCES Groupps(groupId)
    ON DELETE CASCADE

);

-- populating usergroup  table 
INSERT INTO UserGroup(userId,groupId)
VALUES
(1,1),
(2,1),
(3,2),
(4,2),
(5,3);

-- dropping table to allow multiple rerun of screen 
DROP TABLE if EXISTS Rooms;

-- creating room/ table
CREATE TABLE IF NOT EXISTS Rooms (
    roomId INT PRIMARY KEY,
    roomName VARCHAR (25)
);

-- populating rooms table
INSERT INTO Rooms(roomId,roomName)
VALUES 
(101,'Room 101'),
(102,'Room 102'),
(103,'Room Auditorium A'),
(104,'Room Auditorium B');

-- dropping table to allow multiple rerun of screen 
DROP TABLE if EXISTS GroupRoom;
-- creating grouproom table to act as a pivot table 
CREATE TABLE IF NOT EXISTS GroupRoom(
    groupRoomId Serial PRIMARY KEY,
    roomId INT,
    groupId INT,
    CONSTRAINT fk_rooms FOREIGN KEY (roomId) REFERENCES Rooms(roomId)
    ON DELETE CASCADE,

    CONSTRAINT fk_group_rooms FOREIGN KEY (groupId) REFERENCES Groupps(groupId)
    ON DELETE CASCADE

);

-- populating grouproom table  
INSERT INTO GroupRoom(roomId,groupId)
VALUES
(101,1),
(102,1),
(102,2),
(103,2);

-- All groups, and the users in each group. A group should appear even if there are no users assigned to the group.
SELECT Groupps.groupName, Users.userName
FROM Groupps
LEFT JOIN UserGroup ON Groupps.groupId = UserGroup.groupId
LEFT JOIN Users ON UserGroup.userId = Users.userId
ORDER BY Groupps.groupName, Users.userName;

-- 2.All rooms, and the groups assigned to each room. The rooms should appear even if no groups have been
-- assigned to them.
SELECT Rooms.roomName,Groupps.groupName
FROM Rooms
LEFT JOIN GroupRoom ON Rooms.roomId = GroupRoom.roomId
LEFT JOIN Groupps ON GroupRoom.groupId =Groupps.groupId
ORDER BY Rooms.roomName,Groupps.groupName;


-- A list of users, the groups that they belong to, and the rooms to which they are assigned. This should be sorted
-- alphabetically by user, then by group, then by room.
SELECT Users.userName , Groupps.groupName, Rooms.roomName
FROM Users
LEFT JOIN UserGroup  ON Users.userId = UserGroup.userId
LEFT JOIN Groupps  ON UserGroup.groupId = Groupps.groupId
LEFT JOIN GroupRoom  ON Groupps.groupId = GroupRoom.groupId
LEFT JOIN Rooms  ON GroupRoom.roomId = Rooms.roomId
ORDER BY Users.userName , Groupps.groupName, Rooms.roomName;