<?php

use App\Http\Controllers\TasksController;
use App\Http\Controllers\WorkersController;
use Illuminate\Support\Facades\Route;

Route::apiResource('tasks', TasksController::class);
Route::apiResource('workers', WorkersController::class);
