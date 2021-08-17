function Test-ColumnFilter {
    [CmdletBinding()]
    param (
            [parameter()]
            [String]$Filter,
            [parameter()]
            [string[]]$FilterValues,
            [Parameter()]
            [switch]$TestForRawValue
    )
    begin {
            Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if (!$filterValues[0] -or !$filterValues[1]) {
                throw "Column or comparator has not been set in filter $filter!"
        }
        if (($FilterValues[1] -notin $validComparators) -and ($FilterValues[2] -notin $validComparators)) {
                throw "Invalid comparator '$($FilterValues[1])' in filter $filter! For a list of valid comparators, run command 'Get-Help Get-GoItems -Parameter ColumnFilter'"
        }
        if (($FilterValues.Count -eq 3) -and ([string]::IsNullOrWhiteSpace($FilterValues[-1]))) {
                throw "Please supply a rawValue or value for filter ($Filter)"
        }
        Write-Verbose "Filter looks OK ($Filter)"
    }
    end {
            Write-Verbose "$($MyInvocation.MyCommand) completed"
      }
}