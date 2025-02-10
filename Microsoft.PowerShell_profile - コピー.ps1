#notepad $PROFILE// powershellのScriptを作成、自動ユーザーがログイン時点で以下のインストールしたモジュールをロードする

#Nerd Fontをインストール

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

#最後のコマンドは矢印キーを押さないように
Set-PSReadLineKeyHandler -Chord Ctrl+p -Function PreviousHistory
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function NextHistory

#あいまい検索ツールのfzfをGit管理を容易にしてくれるツールghqと組み合わせて使うことで、生産性が劇的に向上します
#ターミナルのどこからでも、GitのProject一覧を検索して、そのディレクトリに移動することができるようになります。
#scoop install ghq
#scoop install fzf
#Install-Module -Name PSFzf
#fzfのキーバインド
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
#installしたら、gitconfigにrootとなるディレクトリを設定する必要があります
#git config --global ghq.root '~\source\repos'
