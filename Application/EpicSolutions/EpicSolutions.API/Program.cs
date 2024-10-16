
using EpicSolutions.API.Interfaces;
using EpicSolutions.API.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.Text;


namespace EpicSolutions.API
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            builder.Services.AddControllers();


            builder.Services.AddScoped<ITokenService, TokenService>();




            builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).AddJwtBearer(options =>
            {
                string? jwtKey = builder.Configuration["Jwt:Key"];
                if (string.IsNullOrEmpty(jwtKey))
                {
                    throw new InvalidOperationException("Jwt:Key is not configured.");
                }

                options.TokenValidationParameters = new()
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey)),
                    ValidateIssuer = false,
                    ValidateAudience = false
                };
            });

            // Add authorization
            builder.Services.AddAuthorization(options =>
            {
                options.AddPolicy("HR Supervisor", policy =>
                {
                    policy.RequireRole("HR Supervisor");
                });
            });

            // Add authorization
            builder.Services.AddAuthorization(options =>
            {
                options.AddPolicy("Regular Supervisor", policy =>
                {
                    policy.RequireRole("Regular Supervisor");
                });
            });

            // Add authorization
            builder.Services.AddAuthorization(options =>
            {
                options.AddPolicy("HR Employee", policy =>
                {
                    policy.RequireRole("HR Employee");
                });
            });

            // Add authorization
            builder.Services.AddAuthorization(options =>
            {
                options.AddPolicy("Regular Employee", policy =>
                {
                    policy.RequireRole("Regular Employee");
                });
            });

            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            // DISABLE MODEL ERRORS SO THAT WE CAN PASS OUR OWN ERRORS BACK
            builder.Services.Configure<ApiBehaviorOptions>(options =>
            {
                options.SuppressModelStateInvalidFilter = true;
            });

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseAuthentication();
            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}
