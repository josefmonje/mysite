from django.http import HttpResponseServerError


def ServerErrorView(request):
    # Return an "Internal Server Error" 500 response code.
    return HttpResponseServerError()
