import pytest
from infrastructure_dns_validation_tool import classify_result

def test_healthy():
    assert (
        classify_result(
            "YES",
            "YES",
            "YES"
        )
        == "Healthy"
    )

def test_review():
    assert (
        classify_result(
            "NO",
            "YES",
            "NO"
        )
        == "Review"
    )


def test_active_no_dns():
    assert (
        classify_result(
            "YES",
            "NO",
            "NO"
        )
        == "Active Host, No DNS Records"
    )

def test_no_response():
    assert (
        classify_result(
            "NO",
            "NO",
            "NO"
        )
        == "No Response / No DNS Records"
    )