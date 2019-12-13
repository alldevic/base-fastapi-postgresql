from arq.connections import RedisSettings

from .globals import REDIS_IP, REDIS_PORT, REDIS_PASSWORD

settings = RedisSettings(host=REDIS_IP,
                         port=REDIS_PORT,
                         password=REDIS_PASSWORD)
