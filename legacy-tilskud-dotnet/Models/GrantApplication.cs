using System;

namespace LegacyTilskud.Models
{
    public class GrantApplication
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string ApplicantName { get; set; }
        public string ApplicantEmail { get; set; }
        public string MunicipalityArea { get; set; }
        public decimal Amount { get; set; }
        public string Status { get; set; }
        public string Description { get; set; }
        public string DecisionNote { get; set; }
        public string CaseWorkerUserName { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public DateTime? SubmittedAt { get; set; }

        public bool IsClosed
        {
            get { return Status == "GODKENDT" || Status == "AFVIST"; }
        }
    }
}
