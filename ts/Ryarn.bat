if exist "yarn.lock" (
  goto :success
)

yarn install

:success




