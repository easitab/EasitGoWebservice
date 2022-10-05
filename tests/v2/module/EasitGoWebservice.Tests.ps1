$ModuleName = 'EasitGoWebservice'

BeforeAll {
    $ModuleName = 'EasitGoWebservice'
    Import-Module $ModuleName
}

Describe "$ModuleName Sanity Tests - Help Content" -Tag 'Module' {

    Import-Module $ModuleName

    $ShouldProcessParameters = 'WhatIf', 'Confirm'

    $Module = Get-Module $ModuleName
    $CommandList = @(
        $Module.ExportedFunctions.Keys
        $Module.ExportedCmdlets.Keys
    )

    foreach ($Command in $CommandList) {
        Context "$Command - Help Content" {

            $Help = @{ Help = Get-Help -Name $Command -Full | Select-Object -Property * }
            $Parameters = Get-Help -Name $Command -Parameter * -ErrorAction Ignore |
                Where-Object { $_.Name -and $_.Name -notin $ShouldProcessParameters } |
                ForEach-Object {
                    @{
                        Name        = $_.name
                        Description = $_.Description.Text
                    }
                }
            $Ast = @{
                # Ast will be $null if the command is a compiled cmdlet
                Ast        = (Get-Content -Path "function:/$Command" -ErrorAction Ignore).Ast
                Parameters = $Parameters
            }
            $Examples = $Help.Help.Examples.Example | ForEach-Object { @{ Example = $_ } }

            It "has help content for $Command" -TestCases $Help {
                $Help | Should -Not -BeNullOrEmpty
            }

            It "contains a synopsis for $Command" -TestCases $Help {
                $Help.Synopsis | Should -Not -BeNullOrEmpty
            }

            It "contains a description for $Command" -TestCases $Help {
                $Help.Description | Should -Not -BeNullOrEmpty
            }

            It "has a help entry for all parameters of $Command" -TestCases $Ast -Skip:(-not ($Parameters -and $Ast.Ast)) {
                @($Parameters).Count | Should -Be $Ast.Body.ParamBlock.Parameters.Count -Because 'the number of parameters in the help should match the number in the function script'
            }

            It "has a description for $Command parameter -<Name>" -TestCases $Parameters -Skip:(-not $Parameters) {
                $Description | Should -Not -BeNullOrEmpty -Because "parameter $Name should have a description"
            }

            It "has at least one usage example for $Command" -TestCases $Help {
                $Help.Examples.Example.Code.Count | Should -BeGreaterOrEqual 1
            }
        }
    }
}