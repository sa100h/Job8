import uvicorn
from fastapi import FastAPI
from starlette.requests import Request
from starlette.responses import RedirectResponse
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()
origins = ['http://176.109.105.12:3123',
           'https://176.109.105.12:3123',
           "http://localhost",
            "http://localhost:8080",
            "*"
            ]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.route('/{_:path}')
async def https_redirect(request: Request):
    return RedirectResponse(request.url.replace(scheme='https'))

if __name__ == '__main__':
    uvicorn.run('https_redirect:app', 
                port=3123, 
                host='0.0.0.0',
                ssl_keyfile='/etc/ssl/private/и-так-сойдет.рф.key',
                ssl_certfile='/etc/ssl/certs/и-так-сойдет.рф.crt'
                )