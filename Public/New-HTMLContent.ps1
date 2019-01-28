Function New-HTMLContent {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, Position = 0)][ValidateNotNull()][ScriptBlock] $Content = $(Throw "Open curly brace with Content"),
        [Parameter(Mandatory = $false)][string]$HeaderText,
        [Parameter(Mandatory = $false)][switch]$IsHidden,
        [RGBColors]$HeaderTextColor = [RGBColors]::White,
        [alias('BackgroundShade')][RGBColors]$BackgroundColor = [RGBColors]::White,
        [Parameter(Mandatory = $false)][switch] $CanCollapse
    )
    Begin {}
    Process {
        $RandomNumber = Get-Random
        $TextHeaderColorFromRGB = ConvertFrom-Color -Color $HeaderTextColor
        $BackGroundColorFromRGB = ConvertFrom-Color -Color $BackgroundColor

        if ($CanCollapse) {
            if ($IsHidden) {
                $ShowStyle = "color: $TextHeaderColorFromRGB" # shows Show button
                $HideStyle = "color: $TextHeaderColorFromRGB; display:none;" # hides Hide button 
            } else {
                $ShowStyle = "color: $TextHeaderColorFromRGB; display:none;" # hides Show button
                $HideStyle = "color: $TextHeaderColorFromRGB;" # shows Hide button 
            }
        } else {
            if ($IsHidden) {
                $ShowStyle = "color: $TextHeaderColorFromRGB;" # shows Show button
                $HideStyle = "color: $TextHeaderColorFromRGB; display:none;" # hides Hide button 
            } else {
                $ShowStyle = "color: $TextHeaderColorFromRGB; display:none"  # hides Show button 
                $HideStyle = "color: $TextHeaderColorFromRGB; display:none;" # hides Show button
            }
        }
        if ($IsHidden) {
            $DivContentStyle = "display:none;background-color:$BackGroundColorFromRGB;"
        } else { 
            $DivContentStyle = "background-color:$BackGroundColorFromRGB;"
        }

    
        $HeaderStyle = "color: $TextHeaderColorFromRGB"
        $Header = New-HTMLAnchor -Name $HeaderText -Text $HeaderText -Style $TextHeaderColorFromRGB
        $Show = New-HTMLAnchor -Id "show_$RandomNumber" -Href '#' -OnClick "show('$RandomNumber');" -Style $ShowStyle -Text '(Show)' 
        $Hide = New-HTMLAnchor -Id "hide_$RandomNumber" -Href '#' -OnClick "hide('$RandomNumber');" -Style $HideStyle -Text '(Hide)' 

        $DivHeader = [Ordered] @{
            Tag        = 'div'
            Attributes = [ordered]@{
                'class' = "header"
            }
            Value      = $Header, $Show, $Hide
        }

        $DivContent = [Ordered] @{
            Tag         = 'div'
            Attributes  = [ordered]@{
                'id'    = $RandomNumber
                'class' = "content"
                'style' = $DivContentStyle 
            }
            Value       = Invoke-Command -ScriptBlock $Content
            SelfClosing = $false
        }

        $DivSection = [Ordered] @{
            Tag        = 'div'
            Attributes = [ordered]@{
                'class' = "section"
            }
            Value      = $DivHeader, $DivContent
        }
        $HTML = Set-Tag -HtmlObject $DivSection
        return $Html
    }
    
}