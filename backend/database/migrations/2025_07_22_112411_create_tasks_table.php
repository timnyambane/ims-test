<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('tasks', function (Blueprint $table) {
            $table->id();
            $table->foreignId('worker_id')->nullable()->onUpdate('cascade')->onDelete('restrict');
            $table->string('title');
            $table->text('description')->nullable();
            $table->enum('status', ['pending', 'active', 'completed'])->default('pending');
            $table->enum('importance', ['low', 'mid', 'high'])->default('mid');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tasks');
    }
};
