using System.Runtime.CompilerServices;
using DiffEngine;

namespace TrekkingForCharity.Client.Tests;

public static class VerifyModuleInitializer
{
    [ModuleInitializer]
    public static void Init()
    {
        DiffRunner.Disabled = true;
    }
}
