$sig = @"
  [DllImport("user32.dll", CharSet = CharSet.Unicode)] public static extern IntPtr FindWindow(String sClassName, String sAppName);
  [DllImport("user32.dll", CharSet = CharSet.Unicode)] public static extern IntPtr GetWindow(IntPtr hWnd, int uCmd);
  [DllImport("User32.dll")] public static extern int SendMessage(IntPtr hWnd, int uMsg, int wParam, string lParam);
"@

$fw = Add-Type -Namespace Win32 -Name Funcs -MemberDefinition $sig -PassThru
$a = $fw::GetWindow($fw::FindWindow( 'Progman', 'Program Manager' ), 5)
$b = $fw::SendMessage($a, 0x111, 0x7402, 0)