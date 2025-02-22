using System;
using System.Collections.Generic;
using System.Data;
using UiPath.CodedWorkflows;
using UiPath.Core;
using UiPath.Core.Activities.Storage;
using UiPath.Orchestrator.Client.Models;
using UiPath.Testing;
using UiPath.Testing.Activities.TestData;
using UiPath.Testing.Activities.TestDataQueues.Enums;
using UiPath.Testing.Enums;
using UiPath.UIAutomationNext.API.Contracts;
using UiPath.UIAutomationNext.API.Models;
using UiPath.UIAutomationNext.Enums;

namespace LibraryFirst
{
    public partial class CodedWorkflow : CodedWorkflowBase
    {
        public CodedWorkflow()
        {
<<<<<<< HEAD:3 курс/1 семестр/РПР/Lab_4/LibraryFirst/.local/install/CodedWorkflow.cs
            _ = new System.Type[]{typeof(UiPath.Testing.API.ITestingService), typeof(UiPath.UIAutomationNext.API.Contracts.IUiAutomationAppService), typeof(UiPath.Core.Activities.API.ISystemService)};
=======
            _ = new System.Type[]{typeof(UiPath.UIAutomationNext.API.Contracts.IUiAutomationAppService), typeof(UiPath.Testing.API.ITestingService), typeof(UiPath.Core.Activities.API.ISystemService)};
>>>>>>> eacde637 (last):Course_3/Sem_1/RPR/Lab_4/LibraryFirst/.local/install/CodedWorkflow.cs
        }

        protected UiPath.Core.Activities.API.ISystemService system { get => serviceContainer.Resolve<UiPath.Core.Activities.API.ISystemService>() ; }

        protected UiPath.Testing.API.ITestingService testing { get => serviceContainer.Resolve<UiPath.Testing.API.ITestingService>() ; }

        protected UiPath.UIAutomationNext.API.Contracts.IUiAutomationAppService uiAutomation { get => serviceContainer.Resolve<UiPath.UIAutomationNext.API.Contracts.IUiAutomationAppService>() ; }
    }
}