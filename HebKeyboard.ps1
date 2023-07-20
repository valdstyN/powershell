Add-Type -AssemblyName System.Windows.Forms

# Define the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Hebrew Keyboard"
$form.Size = New-Object System.Drawing.Size(720, 480)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

# Define the text area
$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Multiline = $true
$textbox.Size = New-Object System.Drawing.Size(680, 400)
$textbox.Location = New-Object System.Drawing.Point(20, 20)
$textbox.TabIndex = 0
$textbox.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes

# Variables to store cursor position
$currentCursorPosition = 0
$previousTextLength = 0

# Event handler for replacing characters as the user types
$textbox.Add_TextChanged({

    $newText = $textbox.Text
    $newText = [regex]::Replace( $newText, 'a','א', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'b','ב', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'c','כ', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'd','ד', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'e','ע', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'f','פ', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'g','ג', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'h','ה', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'i','י', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'j','ח', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'k','כ', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'l','ל', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'm','מ', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'n','נ', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'o','ן', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'p','פ', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'q','ק', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'r','ר', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 's','ס', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 't','ת', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'u','ו', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'v','ו', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'w','ש', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'x','צ', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'y','ט', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'z','ז', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'M','ם', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'N','ן', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'K','ך', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'P','ף', [System.Text.RegularExpressions.RegexOptions]::None)
    $newText = [regex]::Replace( $newText, 'F','ף', [System.Text.RegularExpressions.RegexOptions]::None)


    # Calculate the cursor position adjustment
    $cursorAdjustment = $textbox.SelectionStart - $currentCursorPosition
    $textbox.Text = $newText

    # Set the cursor position after replacement
    $newCursorPosition = $currentCursorPosition + $cursorAdjustment
    $textbox.Select($newCursorPosition, 0)
})

# Event handler to track the cursor position
$textbox.Add_Enter({
    $currentCursorPosition = $textbox.SelectionStart
    $previousTextLength = $textbox.Text.Length
})

# Add the text area to the form
$form.Controls.Add($textbox)

# Define the initial focus
$form.Add_Shown({ $textbox.Focus() })

# Show the form
$form.ShowDialog()
