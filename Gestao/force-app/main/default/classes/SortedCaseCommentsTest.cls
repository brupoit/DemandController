@istest

private class SortedCaseCommentsTest {

    static testmethod void validateSortedCaseComments() {
        case c = new
        case (Subject = 'Test Case', Status = 'New');
        insert c;

        caseComment cc = new CaseComment(CommentBody = 'abc', parentid = c.id);
        insert cc;

        SortedCaseCommentsController sc = new SortedCaseCommentsController();
        sc.AttributeCaseId = c.Id;
        sc.getCaseComments();
    }

}