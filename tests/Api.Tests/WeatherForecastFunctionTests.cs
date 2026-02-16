using System.Reflection;

namespace TrekkingForCharity.Api.Tests;

public class WeatherForecastFunctionTests
{
    [Theory]
    [InlineData(40, "Hot")]
    [InlineData(10, "Cold")]
    [InlineData(0, "Freezing")]
    [InlineData(20, "Mild")]
    public Task GetSummary_MapsTemperatureToLabel(int temp, string expected)
    {
        var function = new HttpTrigger();

        var method = typeof(HttpTrigger).GetMethod("GetSummary", BindingFlags.Instance | BindingFlags.NonPublic);
        if (method is null)
        {
            throw new InvalidOperationException("GetSummary method not found");
        }

        var result = (string)method.Invoke(function, new object[] { temp })!;

        var settings = new VerifySettings();
        settings.UseParameters(temp, expected);

        return Verify(new { Temperature = temp, Result = result, Expected = expected }, settings);
    }
}
