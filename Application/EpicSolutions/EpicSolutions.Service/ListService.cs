using EpicSolutions.Model;
using EpicSolutions.Repo;


namespace EpicSolutions.Service
{
    public class ListService
    {
        #region Private Fields

        private readonly ListsRepo repo = new();

        #endregion     


        #region Public Methods

        public List<DepartmentDTO> GetDepartmentListById(int id)
        {
            return repo.GetDepartmentListById(id);
        }

        public List<PositionListDTO> GetJobAssignmentList()
        {
            return repo.GetJobAssignmentList();
        }

        public List<SupervisorEmployee> GetSupervisorList()
        {
            return repo.GetSupervisorList();
        }

        public List<SupervisorEmployeeDTO> getSupervisorsByPositionId(int positionId)
        {
            return repo.GetSupervisorsByPositionId(positionId);
        }

        public List<RoleDTO> GetRolesListByPositionId(int id)
        {
            return repo.GetRolesList(id);
        }

        public List<RoleDTO> GetRolesList()
        {
            return repo.GetRolesList();
        }

        public List<Status> GetStatusList()
        {
            return repo.GetStatusList();
        }

        public List<Status> GetEmployeeStatusList()
        {
            return repo.GetEmployeeStatusList();
        }

        public List<SupervisorEmployeeDTO> GetSupervisorEmployeeList()
        {
            return repo.GetSupervisorEmployeeList();
        }

        public List<DepartmentDTO> GetDepartmentList()
        {
            return repo.GetDepartmentList();
        }

        public int GetOrderID(string OrderNumber)
        {
            return repo.GetOrderID(OrderNumber);
        }

        public List<RatingDTO> GetRatingList()
        {
            return repo.GetRatingList();
        }

        public List<QuarterDTO> GetQuartersList()
        {
            return repo.GetQuartersList();
        }

        #endregion


        #region Private Methods


        #endregion
    }
}
