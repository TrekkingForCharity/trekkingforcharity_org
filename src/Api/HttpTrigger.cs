using System.Net;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using TrekkingForCharity.Shared;

namespace TrekkingForCharity.Api;

public class HttpTrigger
{
    [Function("WeatherForecast")]
    public HttpResponseData Run([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequestData req)
    {
        var randomNumber = new Random();
        var result = Enumerable.Range(1, 5).Select(index =>
        {
            var temp = randomNumber.Next(-20, 55);

            return new WeatherForecast
            {
                Date = DateTime.Now.AddDays(index),
                TemperatureC = temp,
                Summary = GetSummary(temp)
            };
        }).ToArray();

        var response = req.CreateResponse(HttpStatusCode.OK);
        response.WriteAsJsonAsync(result);

        return response;
    }

    private string GetSummary(int temp)
    {
        var summary = "Mild";

        if (temp >= 32)
        {
            summary = "Hot";
        }
        else if (temp <= 16 && temp > 0)
        {
            summary = "Cold";
        }
        else if (temp <= 0)
        {
            summary = "Freezing";
        }

        return summary;
    }
}
