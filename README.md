# check lines install

{
  /tool fetch url="https://raw.githubusercontent.com/Alna7ari/mikrotik-scripts/main/check-pppoe-out-lines/install"\
  dst-path="check-lines-by-alna7ari/install" keep-result=yes http-method=get;
  /import check-lines-by-alna7ari/install
}
