
using EpicSolutions.API.Interfaces;
using EpicSolutions.Model;
using EpicSolutions.Service;
using EpicSolutions.Web.Models;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using NuGet.Common;

namespace EpicSolutions.Web.Controllers
{
    public class LoginController : Controller
    {

        private readonly LoginService service = new();                   

        [HttpGet]
        public ActionResult Login()
        {
            return View();
        }

        [HttpGet]
        public IActionResult Logout()
        {
            HttpContext.Session.Clear(); // Clears the session
            return RedirectToAction("Index", "Home");
        }

        [HttpPost]
        public async Task<ActionResult> Login(LoginVM vm)
        {           

            if (string.IsNullOrEmpty(vm.EmployeeNumber) && string.IsNullOrEmpty(vm.Password))
            {

                ViewBag.Error = "Employee Number and Password are required.";
                return View();
            }

            if (vm.EmployeeNumber == null)
            {
                ViewBag.Error = "Invalid request.";
                return View();
            }

            if (await service.ValidateRetirementStatus(vm.EmployeeNumber))
            {
                ViewBag.Error = "Access denied due to employee's retirement status";
                return View();
            }

            if (await service.ValidateTerminationStatus(vm.EmployeeNumber))
            {
                ViewBag.Error = "Access denied due to employee's terminated status"; 
                return View();
            }


            var loginDTO = new LoginDTO()
            {
                EmployeeNumber = vm.EmployeeNumber,
                Password = vm.Password
            };

            var user = await service.Login(loginDTO);

            if (user != null)
            {
                // Create session
                HttpContext.Session.SetString("UserNumber", user.EmployeeNumber!);
                HttpContext.Session.SetString("Department", user.Department!);
                HttpContext.Session.SetString("Supervisor", user.Supervisor!);
                HttpContext.Session.SetString("Role", user.RoleName!);
                HttpContext.Session.SetString("UserName", user.EmployeeName!);
                HttpContext.Session.SetString("UserId", (user.EmployeeId).ToString());

                //var userRole = HttpContext.Session.GetString("Role");
                //if (userRole == "HR Supervisor" || userRole == "Regular Supervisor")
                //{
                //    return RedirectToAction("Dashboard", "Dashboard");
                //}


                //Show message
                TempData["SuccessMessage"] = "Login successful.";


                //return RedirectToAction("Index", "Home"); 
            }
            else
            {
                ViewBag.Error = "Invalid credentials.";

            }

            return View();
        }
    }
}
