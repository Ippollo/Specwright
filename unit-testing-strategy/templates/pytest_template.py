"""
Pytest Test Template
====================
A starter template demonstrating best practices for pytest-based unit tests.
Copy and adapt for your project.

Usage:
    pytest path/to/this_file.py -v
"""
import pytest
from typing import Any

# =============================================================================
# FIXTURES (move shared fixtures to conftest.py)
# =============================================================================

@pytest.fixture
def sample_data() -> dict[str, Any]:
    """Fixture providing sample test data."""
    return {
        "id": 1,
        "name": "Test Item",
        "active": True,
    }


@pytest.fixture
def mock_service(mocker):
    """Fixture providing a mocked external service."""
    mock = mocker.patch("your_module.external_service")
    mock.return_value = {"status": "ok"}
    return mock


# =============================================================================
# BASIC TESTS (AAA Pattern)
# =============================================================================

class TestYourFunction:
    """Group related tests in a class."""

    def test_returns_expected_result(self, sample_data):
        # Arrange
        input_value = sample_data["name"]

        # Act
        result = input_value.upper()

        # Assert
        assert result == "TEST ITEM"

    def test_handles_empty_input(self):
        # Arrange
        input_value = ""

        # Act
        result = input_value.upper()

        # Assert
        assert result == ""


# =============================================================================
# PARAMETRIZED TESTS
# =============================================================================

@pytest.mark.parametrize("input_val,expected", [
    ("hello", 5),
    ("world", 5),
    ("", 0),
    ("pytest", 6),
])
def test_string_length(input_val: str, expected: int):
    """Test multiple inputs with parametrize."""
    assert len(input_val) == expected


@pytest.mark.parametrize("a,b,expected", [
    (1, 2, 3),
    (0, 0, 0),
    (-1, 1, 0),
    (100, 200, 300),
])
def test_addition(a: int, b: int, expected: int):
    """Test addition with various inputs."""
    assert a + b == expected


# =============================================================================
# EXCEPTION TESTING
# =============================================================================

def test_raises_value_error():
    """Test that an exception is raised."""
    with pytest.raises(ValueError, match="invalid literal"):
        int("not_a_number")


# =============================================================================
# ASYNC TESTS (requires pytest-asyncio)
# =============================================================================

# @pytest.mark.asyncio
# async def test_async_function():
#     result = await some_async_function()
#     assert result is not None


# =============================================================================
# MOCKING EXAMPLES
# =============================================================================

def test_with_mocked_dependency(mocker):
    """Example of mocking an external dependency."""
    # Arrange
    mock_requests = mocker.patch("requests.get")
    mock_requests.return_value.status_code = 200
    mock_requests.return_value.json.return_value = {"key": "value"}

    # Act - Replace with your actual function call
    # result = your_function_that_calls_requests()

    # Assert
    # mock_requests.assert_called_once()
    # assert result == expected_value
    pass  # Remove this when implementing


# =============================================================================
# RUN CONFIGURATION
# =============================================================================

if __name__ == "__main__":
    pytest.main([__file__, "-v"])
