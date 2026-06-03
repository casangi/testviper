from prefect import flow, task

@task
def compute_data(x: int, y: int) -> int:
    return x + y

@flow
def math_flow(x: int, y: int) -> int:
    result = compute_data(x, y)
    return result