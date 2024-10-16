using EpicSolutions.Model;
using EpicSolutions.Service;
using EpicSolutions.Web.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data;

namespace EpicSolutions.Web.Controllers
{

    public class DashboardController : Controller
    {
        private readonly OrderService service = new();
        private readonly DepartmentService departmentService = new();
        private readonly ReviewService review = new();
        private readonly EmployeeService employee = new();

        // GET: DashboardController
        public ActionResult Index(string successMessage)
        {
            return Redirect("home");
            //ViewBag.SuccessMessage = successMessage;
            //return View();
        }        


        // GET: DashboardController/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: DashboardController/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: DashboardController/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: DashboardController/Personal/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: DashboardController/Personal/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: DashboardController/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: DashboardController/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }


        // GET: DashboardController/Chart
        public ActionResult Chart()
        {

            string? userNumber = HttpContext.Session.GetString("UserNumber");
            string? role = HttpContext.Session.GetString("Role");
            int userId = Convert.ToInt32(HttpContext.Session.GetString("UserId"));

            bool isSupervisor = (role == "HR Employee" || role == "Regular Supervisor");
            
            
            if (userNumber == null)
            {
                return RedirectToAction(nameof(Index));
            }

            ChartVM expenses = new ChartVM();
            
            List<OrderDTO> orders = new();

            expenses.PerformanceCount = review.GetReviewsByEmployeeId(userId).Where(r => r.isRead == false).Count();
            expenses.AllPerformanceCount = review.GetReviewsByEmployeeId(userId).Count();

            if (isSupervisor)
            {
                orders = service.GetPOPerPeriod(userId);
                expenses.ReviewCount = review.GetEmployeeListWithPendingReviews(userId).Count();
                expenses.EmployeeCount = employee.GetEmployeeCountBySupervisor(userId);
            }
            else
            {
                orders = service.GetPOPerPeriodEmployee(userId);
            }

            expenses.Expenses = service.CalculateExpenses(orders);
            return View(expenses);


        }




    }
}
