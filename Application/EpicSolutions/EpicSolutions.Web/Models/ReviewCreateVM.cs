using EpicSolutions.Model;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations;

namespace EpicSolutions.Web.Models
{
    public class ReviewCreateVM
    {
        [Display(Name = "Employee")]
        public string? FullName { get; set; }

        [Display(Name = "Review Year")]
        public int ReviewDate { get; set; }

        [Required(ErrorMessage = "Comment is required.")]
        [Display(Name = "Comment")]
        public string? Comment { get; set; }

        [Required(ErrorMessage = "Completion Date is required.")]
        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:d MMMM yyyy}")]
        [Display(Name = "Completion Date")]   
        public DateTime? CompletionDate { get; set; }

        [Required(ErrorMessage = "Rating is required.")]
        [Display(Name = "Rating")]
        public int RatingId { get; set; }

        public IEnumerable<SelectListItem>? Ratings { get; set; }

        public int EmployeeId { get; set; }

        public int SupervisorId { get; set; }

        public int QuarterId { get; set; }

        [Display(Name = "Review Quarter")]
        public string? QuarterName { get; set; }

    }
}
