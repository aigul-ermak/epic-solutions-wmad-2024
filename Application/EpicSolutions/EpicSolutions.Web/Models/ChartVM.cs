using EpicSolutions.Model;

namespace EpicSolutions.Web.Models
{
    public class ChartVM
    {
        public Dictionary<string, decimal>? Expenses { get; set; }

        public int ReviewCount { get; set; }

        public int PerformanceCount { get; set; }

        public int AllPerformanceCount { get; set; }

        public int EmployeeCount { get; set; }

    }
}
