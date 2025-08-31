version: '2'
services:
  presale:
    build: .
    networks:
      default:
        ipv4_address: 172.16.5.3
    volumes:
      - DEV_REPO_1:/druids.me
      - ./docker:/docker

networks:
  default:
    external:
      name: dev_druidsme_net
