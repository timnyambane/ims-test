<?php

namespace App\Http\Controllers;

use App\Models\Task;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class TasksController extends Controller
{
    public function index(): JsonResponse
    {
        $tasks = Task::with('worker')->get();

        return $tasks->isEmpty()
            ? response()->json(['message' => 'No tasks found'], 404)
            : response()->json($tasks, 200);
    }

    public function store(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'title' => 'required|string|max:255',
                'description' => 'nullable|string',
                'status' => 'in:pending,active,completed',
                'importance' => 'in:low,mid,high',
                'worker_id' => 'nullable|exists:workers,id',
            ]);

            $task = Task::create($validated);
            $task->load('worker');

            return response()->json($task, 201);
        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Validation error',
                'errors' => $e->errors()
            ], 422);
        } catch (\Throwable $e) {
            return response()->json([
                'message' => 'Error creating task',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show(Task $task): JsonResponse
    {
        $task->load('worker');

        return response()->json($task, 200);
    }

    public function update(Request $request, Task $task): JsonResponse
    {
        try {
            $validated = $request->validate([
                'title' => 'sometimes|required|string|max:255',
                'description' => 'nullable|string',
                'status' => 'sometimes|required|in:pending,active,completed',
                'importance' => 'sometimes|required|in:low,mid,high',
                'worker_id' => 'nullable|exists:workers,id',
            ]);

            $task->update($validated);
            $task->load('worker');

            return response()->json($task, 200);
        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Validation error',
                'errors' => $e->errors()
            ], 422);
        } catch (\Throwable $e) {
            return response()->json([
                'message' => 'Error updating task',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy(Task $task): JsonResponse
    {
        $task->delete();

        return response()->json(['message' => 'Task deleted successfully'], 200);
    }
}
