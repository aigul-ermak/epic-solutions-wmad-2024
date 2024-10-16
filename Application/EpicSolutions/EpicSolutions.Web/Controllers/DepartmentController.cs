using EpicSolutions.Model;
using EpicSolutions.Service;
using EpicSolutions.Web.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;

namespace EpicSolutions.Web.Controllers
{

    public class DepartmentController : Controller
    {
       
        private readonly DepartmentService depService = new();

        // GET: DepartmentController

        public ActionResult Index()
        {


            try
            {
                List<Department> departments = depService.GetAllDepartments();
                ViewBag.SuccessMessage = TempData["SuccessMessage"];

                return View(departments);

            }
            catch (Exception ex)
            {
                
                ViewBag.ErrorMessage = "An error occurred while retrieving department data.";
                return View(new List<Department>()); 
            }                 

        }

        public ActionResult Department(int id)
        {
            Department department = depService.GetDepartmentById(id);

            if (department == null)
            {
                return NotFound();
            }

            return View(department); ;
        }

        // GET: DepartmentController/Details/5
        public ActionResult Details(int id)
        {         

            return View();
        }
             

        // GET: DepartmentController/Create
        public ActionResult Create()
        {
            var userRole = HttpContext.Session.GetString("Role");


            if (userRole == null)
            {
                return RedirectToAction("Index", "Home");
            }

           

            return View();
        }

        // POST: DepartmentController/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Department d)
        {
            try
            {
                if (ModelState.IsValid)
                {

                    var result = depService.AddDepartment(d);

                    if (result.Errors.Count == 0)
                    {
                        ViewBag.SuccessMessage = "Department created successfully.";
                        

                    } else
                    {
                        string errorMessage = "";
                        foreach (var error in result.Errors)
                        {
                            errorMessage += error.Description + " ";
                        }
                        ViewBag.ErrorMessage = errorMessage;

                        return View(d);
                    }


                }
                return View();

            }
            catch
            {
                ViewBag.ErrorMessage = "An error occurred while creating the department.";
                return View();
            }
        }

        // GET: DepartmentController/Personal/5
        public ActionResult Edit(int departmentId)
        {

            var userRole = HttpContext.Session.GetString("Role");

            Department department = depService.GetDepartmentById(departmentId);

            if (department == null)
            {
                TempData["ErrorMessage"] = "The requested department does not exist.";               
                return RedirectToAction("Index", "Department");
                
            }

            ViewBag.UserRole = userRole;

            return View(department); 
        }

        // POST: DepartmentController/Personal/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(Department d)
        {
            try
            {
                var userRole = HttpContext.Session.GetString("Role");

                if (ModelState.IsValid)
                {

                    var result = depService.UpdateDepartment(d);

                    if (result.Errors.Count == 0)
                    {   
                        return RedirectToAction("Dashboard", "Employee", new { successMessage = "Department was updated successfully." });
                    }
                    else
                    {
                        string errorMessage = "";
                        foreach (var error in result.Errors)
                        {
                            errorMessage += error.Description + " ";
                        }
                        ViewBag.ErrorMessage = errorMessage;
                        ViewBag.UserRole = userRole;
                        return View(d);
                    }
                }

                ViewBag.UserRole = userRole;

                return View(d);
            }           
            catch(Exception ex)
            {
                ViewBag.ErrorMessage = ex.Message;
                return View(d);
            }
        }

        // GET: DepartmentController/Delete/5
        public ActionResult Delete(int departmentId)
        {
            Department department = depService.GetDepartmentById(departmentId);

            return View(department);
        }

        // POST: DepartmentController/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(Department d)
        {
            try
            {
                var result = depService.DeleteDepartment(d);
                if (result)
                {

                    TempData["SuccessMessage"] = "Department was deleted successfully";
                    return RedirectToAction("Index", "Department");

                }

                return View(d);
            }
            catch (Exception ex)
            {
                ViewBag.ErrorMessage = ex.Message;
                return View(d);
            }
        }
    }
}
