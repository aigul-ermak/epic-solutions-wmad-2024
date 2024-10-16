using EpicSolutions.Model;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations;

namespace EpicSolutions.Web.Models
{
    public class ReviewAddVM
    {
        public List<EmployeeReviewDTO>? Employees { get; set; }

    }
} 
