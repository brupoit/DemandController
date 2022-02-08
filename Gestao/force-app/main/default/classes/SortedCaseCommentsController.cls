public class SortedCaseCommentsController {
  public Id     AttributeCaseId    {get; set;}

  public List<CaseComment> getCaseComments() {
    return [
      SELECT CommentBody, CreatedById, CreatedBy.Name, CreatedDate
      FROM CaseComment
      WHERE ParentId = :this.AttributeCaseId and IsPublished = TRUE
      ORDER BY CreatedDate DESC
    ];
  }
}