using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Model
{
    public class Review :BaseEntity
    {
        public int Id { get; set; }
        public DateOnly ReviewDate { get; set; }

        [Required(ErrorMessage = "Comment is required.")]
        [Display(Name = "Comment")]
        public string? Comment { get; set; }

        [DataType(DataType.Date)]
        [Required(ErrorMessage = "Completion Date is required.")]
        [DisplayFormat(DataFormatString = "{0:d MMMM yyyy}")]
        [Display(Name = "Completion Date")]
        public DateTime CompletionDate { get; set; }

        public bool isRead { get; set; }

        [Required(ErrorMessage = "Rating is required.")]
        public int RatingId { get; set; }

        public int EmployeeId { get; set; }

        public int SupervisorId { get; set; }

        public int QuarterId { get; set; }
    }
}
