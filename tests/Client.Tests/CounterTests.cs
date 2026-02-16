using Bunit;
using VerifyXunit;

namespace TrekkingForCharity.Client.Tests;

public class CounterTests : BunitContext
{
    [Fact]
    public async Task ClickIncrementsCounter()
    {
        var cut = Render<TrekkingForCharity.Client.Pages.Counter>();

        var initialText = cut.Find("p[role='status']").TextContent;

        cut.Find("button").Click();

        var afterClickText = cut.Find("p[role='status']").TextContent;
        await Verify(new { Initial = initialText, AfterClick = afterClickText });
    }
}
