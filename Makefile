all     :; dapp --use solc:0.8.9 build
clean   :; dapp clean
test    :; ./test.sh $(match) $(runs)
cov     :; dapp --use solc:0.8.9 test -v --coverage --cov-match "src\/Wormhole"
snap    :; dapp --use solc:0.8.9 snapshot
certora-fee 	:; certoraRun --solc ~/.solc-select/artifacts/solc-0.8.9 src/WormholeConstantFee.sol --verify WormholeConstantFee:certora/WormholeConstantFee.spec --rule_sanity $(if $(rule),--rule $(rule),) --multi_assert_check --short_output --staging maker/structs
certora-join 	:; certoraRun --solc ~/.solc-select/artifacts/solc-0.8.9 src/WormholeJoin.sol certora/FeesMock.sol certora/Auxiliar.sol src/test/mocks/VatMock.sol src/test/mocks/DaiMock.sol src/test/mocks/DaiJoinMock.sol --link WormholeJoin:vat=VatMock WormholeJoin:daiJoin=DaiJoinMock DaiJoinMock:vat=VatMock DaiJoinMock:dai=DaiMock --verify WormholeJoin:certora/WormholeJoin.spec --rule_sanity $(if $(rule),--rule $(rule),) --multi_assert_check --short_output --smt_timeout 1800 --staging maker/structs
certora-router 	:; certoraRun --solc ~/.solc-select/artifacts/solc-0.8.9 src/WormholeRouter.sol certora/WormholeJoinMock.sol src/test/mocks/DaiMock.sol --link WormholeRouter:dai=DaiMock --verify WormholeRouter:certora/WormholeRouter.spec --rule_sanity $(if $(rule),--rule $(rule),) --multi_assert_check --short_output --staging maker/structs
certora-oracle 	:; certoraRun --solc ~/.solc-select/artifacts/solc-0.8.9 src/WormholeOracleAuth.sol certora/WormholeJoinMock.sol certora/Auxiliar.sol --link WormholeOracleAuth:wormholeJoin=WormholeJoinMock Auxiliar:oracle=WormholeOracleAuth --verify WormholeOracleAuth:certora/WormholeOracleAuth.spec --rule_sanity --optimistic_loop $(if $(rule),--rule $(rule),) --multi_assert_check --short_output --staging maker/structs
