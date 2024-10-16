using EpicSolutions.Model;
using EpicSolutions.Model.DTO;
using EpicSolutions.Service;
using EpicSolutions.Web.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Diagnostics;

namespace EpicSolutions.Web.Controllers
{
    public class ReviewController : Controller
    {

        private readonly ReviewService service = new();
        private readonly ListService listService = new();


        // GET: ReviewController
        public ActionResult Index(int employeeId)
        {
            try
            {
                List<EmployeeReviewDTO> employees = service.GetEmployeeListWithPendingReviews(employeeId);

                List<QuarterDTO> quarters = listService.GetQuartersList();

                foreach (var employee in employees)
                {
                    employee.QuarterName = quarters.FirstOrDefault(q => q.QuarterId == employee.Quarter)?.QuarterName ?? "Unknown";
                }


                ReviewAddVM model = new ReviewAddVM
                {
                    Employees = employees
                };

                ViewBag.SuccessMessage = TempData["SuccessMessage"];

                return View(model);
            }
            catch (Exception ex)
            {
                return ShowError(ex);
            }
        }

        // GET: ReviewController/Details/5
        public ActionResult Detail(int employeeId, int reviewId)
        {
            try
            {
                ReviewEmployeeDTO r = service.GetReviewDetails(reviewId);               

                if (r == null)
                {
                    
                    ViewBag.ErrorMessage = "No review details found.";
                    return View("Error"); 
                }

                Review review = service.GetReviewById(reviewId);

                if (review != null)
                {
                    
                    if (!review.isRead) 
                    {
                        review.isRead = true;
                        service.UpdateReview(review); 
                    }
                }
                else
                {
                    ViewBag.ErrorMessage = "No review found with the given ID.";
                    return View("Error");
                }
               
                return View(r);
            } catch (Exception ex)
            {
                ViewBag.ErrorMessage = "An error occurred while retrieving review details.";
                return View("Error");
            }
           
        }
      

        // GET: ReviewController/Create
        public ActionResult Create(int employeeId, int year, int quarter, string firstName, string lastName)
        {
            try
            {
                List<RatingDTO> ratings = listService.GetRatingList();

                var ratingSelectedListItems = ratings.Select(r => new SelectListItem
                {
                    Value = r.RatingId.ToString(),
                    Text = r.RatingName
                }).ToList();

                List<QuarterDTO> quarters = listService.GetQuartersList();


                int supervisorId = Convert.ToInt32(HttpContext.Session.GetString("UserId"));


                ReviewCreateVM r = new ReviewCreateVM
                {
                    FullName = lastName + ", " + firstName,
                    ReviewDate = year,
                    Comment = "",
                    CompletionDate = DateTime.Now,
                    Ratings = ratingSelectedListItems,
                    EmployeeId = employeeId,
                    SupervisorId = supervisorId,
                    QuarterId = quarter,
                    QuarterName = quarters.FirstOrDefault(q => q.QuarterId == quarter)?.QuarterName ?? "Not found"
                };


                return View(r);
            }
            catch (Exception ex)
            {
                return ShowError(ex);
            }
        }


        // POST: ReviewController/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(ReviewCreateVM r)
        {
            try
            {               

                if (!ModelState.IsValid)
                {
                    r.Ratings = GetRatingSelectListItems();
                    return View(r);
                }

                Review newReview = new Review
                {
                    ReviewDate = DateOnly.FromDateTime(new DateTime(r.ReviewDate, 1, 1)),
                    Comment = r.Comment,
                    CompletionDate = r.CompletionDate ?? DateTime.Today,
                    RatingId = r.RatingId,                    
                    EmployeeId = r.EmployeeId,
                    SupervisorId = r.SupervisorId,
                    QuarterId = r.QuarterId,
                    isRead = false
                };

                var result = service.AddReview(newReview);

                if (result.Errors.Count == 0)
                {
                    TempData["SuccessMessage"] = "Review added successfully";
                    return RedirectToAction("Index", "Review", new { employeeId = r.SupervisorId });
                }
                else
                {
                    string errorMessage = "";
                    foreach (var error in result.Errors)
                    {
                        errorMessage += error.Description + " ";
                    }
                    ViewBag.ErrorMessage = errorMessage;

                    r.Ratings = GetRatingSelectListItems();
                    return View(r);
                }

            }
            catch (Exception ex)
            {
                ViewBag.ErrorMessage = ex.Message;
                r.Ratings = GetRatingSelectListItems();
                return View(r);
            }
        }

        // GET: Reviews
        public ActionResult Reviews(int employeeId)
        {
            try
            {
                List<ReviewListDTO> reviews = service.GetReviewsByEmployeeId(employeeId);

                return View(reviews); 
            }
            catch (Exception ex)
            {
                
                ViewBag.ErrorMessage = ex.Message;
                return View("Error"); 
            }
        }


        #region Private Methods

        private List<SelectListItem> GetRatingSelectListItems()
        {
            var ratings = listService.GetRatingList().Select(rate => new SelectListItem
            {
                Value = rate.RatingId.ToString(),
                Text = rate.RatingName
            }).ToList();

            return ratings;
        }

        private ActionResult ShowError(Exception ex)
        {
            return View("Error", new ErrorViewModel
            {
                RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier,
                Exception = ex
            });
        }

        #endregion
    }
}
