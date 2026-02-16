using System.Runtime.CompilerServices;
using DiffEngine;

namespace TrekkingForCharity.Api.Tests;

public static class VerifyModuleInitializer
{
    [ModuleInitializer]
    public static void Init()
    {
        DiffRunner.Disabled = true;
    }
}
