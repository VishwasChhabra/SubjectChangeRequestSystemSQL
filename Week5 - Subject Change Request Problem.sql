CREATE TABLE SubjectAllotments (
    StudentId VARCHAR(255) NOT NULL,
    SubjectId VARCHAR(255) NOT NULL,
    Is_valid BIT NOT NULL
);

INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_valid) VALUES ('159103036', 'PO1496', 1);
INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_valid) VALUES ('159103036', 'PO1491', 0);
INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_valid) VALUES ('159103036', 'PO1492', 0);
INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_valid) VALUES ('159103036', 'PO1493', 0);
INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_valid) VALUES ('159103036', 'PO1494', 0);
INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_valid) VALUES ('159103036', 'PO1495', 0);

CREATE TABLE SubjectRequest (
    StudentId VARCHAR(255) NOT NULL,
    SubjectId VARCHAR(255) NOT NULL
);

INSERT INTO SubjectRequest (StudentId, SubjectId) VALUES ('159103036', 'PO1496');

DELIMITER //

CREATE PROCEDURE HandleSubjectChange()
BEGIN
    DECLARE req_StudentId VARCHAR(255);
    DECLARE req_SubjectId VARCHAR(255);
    
    DECLARE student_exists INT;
    
    DECLARE current_valid_SubjectId VARCHAR(255);
    
    DECLARE cur_requests CURSOR FOR
        SELECT StudentId, SubjectId FROM SubjectRequest;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET @finished = TRUE;
    
    SET @finished = FALSE;

    OPEN cur_requests;

    get_request: LOOP
        FETCH cur_requests INTO req_StudentId, req_SubjectId;

        IF @finished THEN
            LEAVE get_request;
        END IF;

        SELECT COUNT(*)
        INTO student_exists
        FROM SubjectAllotments
        WHERE StudentId = req_StudentId;

        IF student_exists = 0 THEN
            INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_valid)
            VALUES (req_StudentId, req_SubjectId, 1);
        ELSE
            SELECT SubjectId
            INTO current_valid_SubjectId
            FROM SubjectAllotments
            WHERE StudentId = req_StudentId AND Is_valid = 1;

            IF current_valid_SubjectId IS NOT NULL AND current_valid_SubjectId <> req_SubjectId THEN
                UPDATE SubjectAllotments
                SET Is_valid = 0
                WHERE StudentId = req_StudentId AND Is_valid = 1;

                INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_valid)
                VALUES (req_StudentId, req_SubjectId, 1);
            END IF;
        END IF;
    END LOOP get_request;

    CLOSE cur_requests;


END //

DELIMITER ;

CALL HandleSubjectChange();

SELECT * FROM SubjectAllotments ORDER BY StudentId, SubjectId;