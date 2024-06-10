#Powershellインストール

#windows Terminalをインストール

#Scoopをインストール：
#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
#Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

#git をインストール：scoop install git

#repository 追加
#scoop bucket add extras

#notepad $PROFILE// powershellのScriptを作成、自動ユーザーがログイン時点で以下のインストールしたモジュールをロードする

#Nerd Fontをインストール:
#scoop bucket add nerd-fonts
#scoop install Meslo-NF
#Windows Terminalの外観→既定値→フォントフェイスをNerd Fontを選択する

#oh-my-poshインストールscoop install oh-my-posh

#ターミナル起動時にoh-my-poshのテーマを読み込ませる(絶対パス：C:\Users\SPI\AppData\Local\Programs\oh-my-posh\themes\paradox.omp.json)
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\blue-owl.omp.json" | Invoke-Expression

#posh-git のインストール scoop install posh-git

<#posh-gitはGitとPowerShellを統合したPowerShellのモジュールです。
Gitディレクトリ上に現在のブランチ名やステータス情報を表示してくれて、Gitコマンドのタブ補完機能も提供してくれます。
#>
Import-Module posh-git

#タブ補完時に検索候補を複数表示したい
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
#最後のコマンドは矢印キー↑↓を押さないように-Chordはkey名を指定する、-Functionはfunction名を指定する
Set-PSReadLineKeyHandler -Chord Ctrl+p -Function PreviousHistory
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function NextHistory
# ***→矢印キーとスペースキーバインドする(よく使われる)***
Set-PSReadLineKeyHandler -Chord Ctrl+Spacebar -Function ForwardChar

#Scoopのタブ補完をインストール scoop install scoop-completion

<#デフォルトではScoopのコマンドのタブ補完がないため何度も最後までコマンドをうたなければなりません。
Scoopのタブ補完機能を追加してくれるアプリがありましたので、追加して有効化します。
#>
Import-Module "$($(Get-Item $(Get-Command scoop.ps1).Path).Directory.Parent.FullName)\modules\scoop-completion"

#terminal-iconsモジュールインストール scoop install terminal-icons

#ターミナルにアイコンを表示するのをImportする
Import-Module Terminal-Icons

#GitHubリポジトリにマージするために、毎回ブラウザを開いてPRするのは面倒です。GitHub CLIをインストール
#scoop install gh
#gh使い方：
#gh --version
#gh auth login
#gh auth status
#gh pr mergeマージを実行

#GitHub CLIには公式でタブ補完ツールが提供されていますので、補完有効化を$PROFILEに追加する
Invoke-Expression -Command $(gh completion -s powershell | Out-String)

#PowerShellでAzure CLI のタブ補完有効
Register-ArgumentCompleter -Native -CommandName az -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    $completion_file = New-TemporaryFile
    $env:ARGCOMPLETE_USE_TEMPFILES = 1
    $env:_ARGCOMPLETE_STDOUT_FILENAME = $completion_file
    $env:COMP_LINE = $wordToComplete
    $env:COMP_POINT = $cursorPosition
    $env:_ARGCOMPLETE = 1
    $env:_ARGCOMPLETE_SUPPRESS_SPACE = 0
    $env:_ARGCOMPLETE_IFS = "`n"
    $env:_ARGCOMPLETE_SHELL = 'powershell'
    az 2>&1 | Out-Null
    Get-Content $completion_file | Sort-Object | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
    }
    Remove-Item $completion_file, Env:\_ARGCOMPLETE_STDOUT_FILENAME, Env:\ARGCOMPLETE_USE_TEMPFILES, Env:\COMP_LINE, Env:\COMP_POINT, Env:\_ARGCOMPLETE, Env:\_ARGCOMPLETE_SUPPRESS_SPACE, Env:\_ARGCOMPLETE_IFS, Env:\_ARGCOMPLETE_SHELL
}
#タブ補完時に検索候補を複数表示したい
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

#visual studio codeターミナル(powershellのdebug)に文字化けしないように
#$OutputEncoding = [System.Text.Encoding]::UTF8 #この設定はvscodeのterminal.integrated.profiles.window->Powershell->argsに設定する
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8