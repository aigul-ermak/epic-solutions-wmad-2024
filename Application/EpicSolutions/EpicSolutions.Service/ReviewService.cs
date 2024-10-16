using EpicSolutions.Model;
using EpicSolutions.Model.DTO;
using EpicSolutions.Repo;
using EpicSolutions.Types;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Service
{
    public class ReviewService
    {

        #region Private Fields

        private readonly ReviewRepo repo = new();

        #endregion


        #region Public Methods


        public  List<EmployeeReviewDTO> GetEmployeeListWithPendingReviews(int supervisorId)
        {
            return  repo.GetEmployeeListWithPendingReviews(supervisorId);
        }

        public List<ReviewListDTO> GetReviewsByEmployeeId(int employeeId)
        {
            return repo.GetReviewsByEmployeeId(employeeId);
        }

         public ReviewEmployeeDTO GetReviewDetails(int reviewId)
        {
            return repo.GetReviewDetails(reviewId);
        }

        public Review AddReview(Review r)
        {

            if (ValidateReview(r))
                return repo.AddReview(r);

            return r;
        }

        public bool UpdateReview(Review r)
        {
                        
                return repo.UpdateReview(r);

            
        }

        public Review GetReviewById(int reviewId)
        {

            return repo.GetReviewById(reviewId);


        }

        #endregion

        #region  Private Methods 

        private bool ValidateReview(Review r)
        {

            r.Errors.Clear();

            ValidateCompletionDate(r);

            ValidateCompletionDateBasedOnQuarter(r);

            return r.Errors.Count == 0;
        }

        private void ValidateCompletionDate(Review r)
        {
            if (r.CompletionDate > DateTime.Today)
            {
                r.Errors.Add(new("Completion date cannot be in the future.", ErrorType.Business));
                return;
            }
        }

        private void ValidateCompletionDateBasedOnQuarter(Review r)
        {         

            DateTime quarterStartDate = GetQuarterStartDate(r.ReviewDate.Year, r.QuarterId);

            if (r.CompletionDate < quarterStartDate)
            {
                r.Errors.Add(new("Review cannot be created before the quarter has started.", ErrorType.Business));
                return;
            }

        }

        private DateTime GetQuarterStartDate(int year, int quarterId)
        {
            
            switch (quarterId)
            {
                case 1:
                    return new DateTime(year, 1, 1);  // Q1 starts on January 1
                case 2:
                    return new DateTime(year, 4, 1);  // Q2 starts on April 1
                case 3:
                    return new DateTime(year, 7, 1);  // Q3 starts on July 1
                case 4:
                    return new DateTime(year, 10, 1); // Q4 starts on October 1
                default:
                    throw new ArgumentException("Invalid QuarterId.");
            }
        }

        #endregion
    }

}
