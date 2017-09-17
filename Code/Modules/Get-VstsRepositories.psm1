function Get-VstsRepositories() {
    $response = Get-RestVsts -U "_apis/git/repositories/" -V 1.0
    $response.value
}