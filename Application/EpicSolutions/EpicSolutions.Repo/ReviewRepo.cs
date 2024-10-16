using DAL;
using EpicSolutions.Model;
using EpicSolutions.Model.DTO;
using EpicSolutions.Types;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EpicSolutions.Repo
{
    public class ReviewRepo
    {
        #region Private Fields

        private readonly DataAccess db = new();

        #endregion


        #region Public Methods

        public List<EmployeeReviewDTO> GetEmployeeListWithPendingReviews(int supervisorId)
        {
            List<Parm> parms = new List<Parm>
             {
              new Parm("@SupervisorId", SqlDbType.Int, supervisorId)
             };

            DataTable dt = db.Execute("spGetEmployeesWithPendingReviews", parms);
            List<EmployeeReviewDTO> employees = new List<EmployeeReviewDTO>();

            foreach (DataRow row in dt.Rows)
            {
                employees.Add(new EmployeeReviewDTO
                {
                    Year = Convert.ToInt32(row["Year"]),
                    Quarter = Convert.ToInt32(row["QuarterId"]),
                    EmployeeId = Convert.ToInt32(row["EmployeeId"]),
                    FirstName = row["FirstName"].ToString(),
                    LastName = row["LastName"].ToString()
                });
            }

            return employees;
        }


        public Review AddReview(Review r)
        {

            try
            {
                List<Parm> parms = new List<Parm>
             {
              new Parm("@ReviewYear", SqlDbType.Date, r.ReviewDate),
              new Parm("@Comment", SqlDbType.NVarChar, r.Comment, 255),
              new Parm("@CompletionDate", SqlDbType.DateTime, r.CompletionDate),
              new Parm("@isRead", SqlDbType.Bit, r.isRead),
              new Parm("@RatingId", SqlDbType.Int, r.RatingId),
              new Parm("@EmployeeId", SqlDbType.Int, r.EmployeeId),
              new Parm("@SupervisorId", SqlDbType.Int, r.SupervisorId),
              new Parm("@QuarterId", SqlDbType.Int, r.QuarterId),
             };

                int affectedRow = db.ExecuteNonQuery("spAddReview", parms);

                if (affectedRow > 0)
                {
                    return r;
                }

                return r;

            }
            catch (Exception ex)
            {
                throw new ApplicationException("An error occurred while adding Review", ex);
            }
        }

        public bool UpdateReview(Review r)
        {

            try
            {
                List<Parm> parms = new List<Parm>
                {
                    new Parm("@ReviewId", SqlDbType.Int, r.Id),
                    new Parm("@isRead", SqlDbType.Bit, r.isRead),              
                };

                int affectedRow = db.ExecuteNonQuery("spUpdateReview", parms);

                return affectedRow > 0;

            }
            catch (Exception ex)
            {
                throw new ApplicationException("An error occurred while updating Review", ex);
            }
        }


        public List<ReviewListDTO> GetReviewsByEmployeeId(int employeeId)
        {
            List<Parm> parms = new List<Parm>
             {
              new Parm("@EmployeeId", SqlDbType.Int, employeeId)
             };

            DataTable dt = db.Execute("spGetReviewsByEmployeeId", parms);
            List<ReviewListDTO> employees = new List<ReviewListDTO>();

            foreach (DataRow row in dt.Rows)
            {
                employees.Add(new ReviewListDTO
                {
                    ReviewId = Convert.ToInt32(row["ReviewId"]),
                    EmployeeId = Convert.ToInt32(row["EmployeeId"]),
                    Id = Convert.ToInt32(row["ReviewId"]),
                    isRead = Convert.ToBoolean(row["isRead"]),
                    Year = Convert.ToInt32(row["Year"]),
                    QuarterName = row["QuarterName"].ToString()
                });
            }

            return employees;
        }

        public Review GetReviewById(int reviewId)
        {
            List<Parm> parms = new List<Parm>
             {
              new Parm("@ReviewId", SqlDbType.Int, reviewId)
             };

            DataTable dt = db.Execute("spGetReviewById", parms);

            if (dt != null && dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                Review review = new Review()
                {                    
                    Id = Convert.ToInt32(row["ReviewId"]),
                    ReviewDate = row["Year"] != DBNull.Value ? DateOnly.FromDateTime(new DateTime(Convert.ToInt32(row["Year"]), 1, 1)) : DateOnly.MinValue,                   
                    Comment = row["Comment"].ToString(),
                    CompletionDate = Convert.ToDateTime(row["CompletionDate"]),
                    isRead = Convert.ToBoolean(row["isRead"]),
                    RatingId = Convert.ToInt32(row["RatingId"]),
                    EmployeeId = Convert.ToInt32(row["EmployeeId"]),
                    QuarterId = Convert.ToInt32(row["QuarterId"]),
                    SupervisorId = Convert.ToInt32(row["SupervisorEmployee"]),

                };
                return review;
            }

            return null;
        }

        //public ReviewEmployeeDTO GetReviewDetails(int employeeId)
        //{
        //    List<Parm> parms = new List<Parm>
        //     {
        //      new Parm("@EmployeeId", SqlDbType.Int, employeeId)
        //     };

        //    DataTable dt = db.Execute("spGetReviewDetails", parms);

        //    if (dt != null && dt.Rows.Count > 0)
        //    {
        //        DataRow row = dt.Rows[0];


        //        int year = row["Year"] != DBNull.Value ? Convert.ToInt32(row["Year"]) : 0;
        //        string quarterName = row["QuarterName"].ToString();
        //        DateTime completionDate = row["CompletionDate"] != DBNull.Value ? Convert.ToDateTime(row["CompletionDate"]) : default(DateTime);
        //        string supervisorFullName = row["SupervisorFullName"].ToString();
        //        string comment = row["Comment"].ToString();
        //        string ratingName = row["RatingName"].ToString();

        //        ReviewEmployeeDTO r = new ReviewEmployeeDTO(                  
        //            year,
        //            quarterName,
        //            completionDate,
        //            supervisorFullName,
        //            comment,
        //            ratingName
        //        );

        //        return r;
        //    }

        //    return null;
        //}


        public ReviewEmployeeDTO GetReviewDetails(int reviewId)
        {
            List<Parm> parms = new List<Parm>
             {
              new Parm("@ReviewId", SqlDbType.Int, reviewId)
             };

            DataTable dt = db.Execute("spGetReviewDetails", parms);

            if (dt != null && dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];


                int year = row["Year"] != DBNull.Value ? Convert.ToInt32(row["Year"]) : 0;
                string quarterName = row["QuarterName"].ToString();
                DateTime completionDate = row["CompletionDate"] != DBNull.Value ? Convert.ToDateTime(row["CompletionDate"]) : default(DateTime);
                string supervisorFullName = row["SupervisorFullName"].ToString();
                string comment = row["Comment"].ToString();
                string ratingName = row["RatingName"].ToString();

                ReviewEmployeeDTO r = new ReviewEmployeeDTO(
                    year,
                    quarterName,
                    completionDate,
                    supervisorFullName,
                    comment,
                    ratingName
                );

                return r;
            }

            return null;
        }

        #endregion


        #region Private Methods



        #endregion
    }
}
