<?php

namespace App\Http\Controllers;

use App\Models\Worker;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class WorkersController extends Controller
{
    public function index(): JsonResponse
    {
        $workers = Worker::all();

        return $workers->isEmpty()
            ? response()->json(['message' => 'No workers found'], 404)
            : response()->json($workers, 200);
    }

    public function store(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|string|email|max:255|unique:workers',
            ]);

            $worker = Worker::create($validated);

            return response()->json($worker, 201);
        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Validation error',
                'errors' => $e->errors()
            ], 422);
        } catch (\Throwable $e) {
            return response()->json([
                'message' => 'Error creating worker',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show(Worker $worker): JsonResponse
    {
        return response()->json($worker, 200);
    }

    public function update(Request $request, Worker $worker): JsonResponse
    {
        try {
            $validated = $request->validate([
                'name' => 'sometimes|required|string|max:255',
                'email' => 'sometimes|required|string|email|max:255|unique:workers,email,' . $worker->getKey(),
            ]);

            $worker->update($validated);

            return response()->json($worker, 200);
        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Validation error',
                'errors' => $e->errors()
            ], 422);
        } catch (\Throwable $e) {
            return response()->json([
                'message' => 'Error updating worker',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy(Worker $worker): JsonResponse
    {
        $worker->delete();

        return response()->json(['message' => 'Worker deleted successfully'], 200);
    }
}
