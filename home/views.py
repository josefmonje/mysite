from django.http import HttpResponseServerError


def server_error_view(request):
    # Return an "Internal Server Error" 500 response code.
    return HttpResponseServerError()
